document.addEventListener('turbolinks:load', function() {
  // 日付選択フィールドの連携
  const startDateField = document.getElementById('start_date');
  const endDateField = document.getElementById('end_date');
  
  if (startDateField && endDateField) {
    startDateField.addEventListener('change', function() {
      if (startDateField.value && 
         (!endDateField.value || new Date(endDateField.value) < new Date(startDateField.value))) {
        endDateField.value = startDateField.value;
      }
    });
  }
  
  // サイドバーの位置を調整（オプション）
  const stickyTop = document.querySelector('.sticky-top');
  if (stickyTop) {
    const headerHeight = document.querySelector('header') ? 
                         document.querySelector('header').offsetHeight : 0;
    stickyTop.style.top = (headerHeight + 20) + 'px';
  }
});