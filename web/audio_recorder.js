let audioContext;
let mediaRecorder;
let audioChunks = [];
let isRecording = false;
let silenceTimeout;

function startRecording() {
  if (!audioContext) {
    audioContext = new (window.AudioContext || window.webkitAudioContext)();
  }

  navigator.mediaDevices.getUserMedia({ audio: true })
    .then(stream => {
      mediaRecorder = new MediaRecorder(stream);
      mediaRecorder.ondataavailable = event => {
        if (event.data.size > 0) {
          audioChunks.push(event.data);
        }
      };

      mediaRecorder.onstop = async () => {
        const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
        audioChunks = [];
        const arrayBuffer = await audioBlob.arrayBuffer();
        const audioBytes = new Uint8Array(arrayBuffer);
        onAudioRecorded(audioBytes);
      };

      mediaRecorder.start();
      isRecording = true;
      checkForSilence(stream);
    })
    .catch(error => {
      console.error('Error accessing audio stream:', error);
    });
}

function stopRecording() {
  if (mediaRecorder && isRecording) {
    mediaRecorder.stop();
    isRecording = false;
  }
}

function checkForSilence(stream) {
  const source = audioContext.createMediaStreamSource(stream);
  const analyser = audioContext.createAnalyser();
  source.connect(analyser);
  analyser.fftSize = 2048;
  const bufferLength = analyser.fftSize;
  const dataArray = new Uint8Array(bufferLength);

  function detectSilence() {
    analyser.getByteTimeDomainData(dataArray);
    let silenceDetected = true;
    for (let i = 0; i < bufferLength; i++) {
      if (dataArray[i] > 128 + 10 || dataArray[i] < 128 - 10) {
        silenceDetected = false;
        break;
      }
    }
    if (silenceDetected) {
      if (!silenceTimeout) {
        silenceTimeout = setTimeout(stopRecording, 2000);
      }
    } else {
      clearTimeout(silenceTimeout);
      silenceTimeout = null;
    }
    if (isRecording) {
      requestAnimationFrame(detectSilence);
    }
  }

  detectSilence();
}
