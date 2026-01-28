// Identity Setup - Camera functionality for KYC verification

let identityStream = null;
let identityPhotoData = null;

// Initialize Identity Setup
document.getElementById('identityBtn').addEventListener('click', async () => {
    const output = document.getElementById('identityOutput');
    const video = document.getElementById('identityVideo');
    const captureBtn = document.getElementById('captureBtn');

    output.style.display = 'block';
    output.innerHTML = '<span class="info">Requesting camera access...</span>';

    try {
        // Request camera access
        identityStream = await navigator.mediaDevices.getUserMedia({
            video: {
                facingMode: 'user',
                width: { ideal: 640 },
                height: { ideal: 480 }
            }
        });

        // Show video element
        video.style.display = 'block';
        video.srcObject = identityStream;

        output.innerHTML = '<span class="success">Camera access granted!</span><br><span class="info">Position yourself in the frame</span>';

        // Show capture photo button
        captureBtn.style.display = 'inline-block';

    } catch (error) {
        output.innerHTML = `<span class="error">Error: ${error.message}</span><br>
            <span class="info">Please allow camera access to continue with identity verification.</span>`;
    }
});

// Capture Photo button
document.getElementById('captureBtn').addEventListener('click', captureIdentityPhoto);

// Capture photo from video stream
async function captureIdentityPhoto() {
    const output = document.getElementById('identityOutput');
    const video = document.getElementById('identityVideo');
    const canvas = document.getElementById('identityCanvas');
    const captureBtn = document.getElementById('captureBtn');
    const context = canvas.getContext('2d');

    // Set canvas dimensions to match video
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    // Draw current video frame to canvas
    context.drawImage(video, 0, 0, canvas.width, canvas.height);

    // Hide video and capture button, show captured image
    video.style.display = 'none';
    captureBtn.style.display = 'none';
    canvas.style.display = 'block';

    output.innerHTML = '<span class="info">Processing...</span>';

    // Draw rainbow and pot of gold watermark with animation
    await drawRainbowWatermark(context, canvas.width, canvas.height);

    // Stop camera stream
    if (identityStream) {
        identityStream.getTracks().forEach(track => track.stop());
    }

    // Wait 0.75 seconds before drawing VERIFIED watermark
    await new Promise(resolve => setTimeout(resolve, 1250));

    // Draw VERIFIED watermark with animation
    await drawVerifiedWatermark(context, canvas.width, canvas.height);

    // Get image data
    identityPhotoData = canvas.toDataURL('image/png');

    output.innerHTML = `<span class="success">Photo captured successfully!</span><br>
        <span class="info">Identity verification complete. You may now proceed to the next step.</span><br>
        <span class="info">Photo size: ${Math.round(identityPhotoData.length / 1024)} KB</span>`;

    // Enable next step
    document.getElementById('registerBtn').disabled = false;
}


// Draw rainbow and pot of gold watermark
async function drawRainbowWatermark(context, width, height) {
    const scale = Math.min(width, height) / 300;
    const x = width / 2;
    const y = height;
    const radius = 75 * scale;

    // Rainbow colors (ROYGBIV)
    const colors = ['#FF0000', '#FF7F00', '#FFFF00', '#00FF00', '#0000FF', '#4B0082', '#9400D3'];

    // Draw rainbow arcs from violet to red (innermost to outermost)
    for (let i = colors.length - 1; i >= 0; i--) {
        context.beginPath();
        context.arc(x, y, radius - (i * 5 * scale), Math.PI, 0, false);
        context.strokeStyle = colors[i];
        context.lineWidth = 5 * scale;
        context.stroke();

        // Wait 80ms before next color
        if (i > 0) {
            await new Promise(resolve => setTimeout(resolve, 80));
        }
    }

    // Draw dark brown pot at the end of the rainbow
    const potX = x + radius - 20 * scale;
    const potY = y - 25 * scale;

    // Pot body (trapezoid)
    context.beginPath();
    context.moveTo(potX - 15 * scale, potY);
    context.lineTo(potX + 15 * scale, potY);
    context.lineTo(potX + 12 * scale, potY + 25 * scale);
    context.lineTo(potX - 12 * scale, potY + 25 * scale);
    context.closePath();
    context.fillStyle = '#3E2723';
    context.fill();
    context.strokeStyle = '#FFFFFF';
    context.lineWidth = 4 * scale;
    context.stroke();

    // Draw 3 golden coins on top of the pot
    const coinRadius = 10 * scale;
    const coinY = potY - 5 * scale;

    for (let i = 0; i < 3; i++) {
        const offsetX = (i - 1) * 12 * scale;
        const offsetY = Math.abs(i - 1) * -5 * scale;

        // Draw golden coin circle
        context.beginPath();
        context.arc(potX + offsetX, coinY + offsetY, coinRadius, 0, 2 * Math.PI);
        context.fillStyle = '#FFD700';
        context.fill();
        context.strokeStyle = '#DAA520';
        context.lineWidth = 2 * scale;
        context.stroke();

        // Draw heart emoji on all coins
        context.font = `${coinRadius * 1.4}px Arial`;
        context.textAlign = 'center';
        context.textBaseline = 'middle';
        context.fillText('❤', potX + offsetX, coinY + offsetY);
        if (i < 11) {
            await new Promise(resolve => setTimeout(resolve, 80));
        }
        context.restore();
    }
}

// Draw VERIFIED watermark in top left with letter-by-letter animation
async function drawVerifiedWatermark(context, width, height) {
    const text = 'ID VERIFIED';
    const fontSize = Math.min(width, height) * 0.2;
    const padding = fontSize * 0.3;

    context.save();
    context.globalAlpha = 0.75;
    context.font = `bold ${fontSize}px Impact, sans-serif`;
    context.fillStyle = '#FFFFFF';
    context.textAlign = 'left';
    context.textBaseline = 'top';

    // Draw each letter with a delay
    for (let i = 1; i <= text.length; i++) {
        // Draw just the current letter at its position
        const currentLetter = text[i - 1];
        const textBeforeCurrent = text.substring(0, i - 1);
        const xPosition = padding + context.measureText(textBeforeCurrent).width;

        context.fillText(currentLetter, xPosition, padding);

        // Wait 50ms before next letter
        if (i < text.length) {
            await new Promise(resolve => setTimeout(resolve, 80));
        }
    }

    context.restore();
}
