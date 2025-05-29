document.addEventListener('turbolinks:load', () => {
  const imageInput = document.getElementById('post_image');
  const preview = document.getElementById('image-preview');
  
  if (imageInput && preview) {
    imageInput.addEventListener('change', (e) => {
      const file = e.target.files[0];
      
      if (file && file.type.match('image.*')) {
        const reader = new FileReader();
        
        reader.onload = (e) => {
          preview.innerHTML = `
            <div class="mt-3">
              <p class="text-muted">プレビュー:</p>
              <img src="${e.target.result}" class="img-fluid rounded" style="max-width: 300px;">
            </div>
          `;
        };
        
        reader.readAsDataURL(file);
      }
    });
  }
});