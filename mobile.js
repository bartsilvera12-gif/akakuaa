/* mobile.js — inyecta botón hamburguesa + drawer en subpáginas
   que usan <header class="site"> con un <nav> interno. */
(function(){
  function init(){
    var header = document.querySelector('header.site');
    if(!header) return;
    var wrap = header.querySelector('.wrap') || header.firstElementChild;
    var nav  = header.querySelector('nav');
    if(!wrap || !nav) return;
    if(header.querySelector('.mobile-menu-btn')) return; // ya inyectado

    // Botón hamburguesa
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'mobile-menu-btn';
    btn.setAttribute('aria-label','Abrir menú');
    btn.setAttribute('aria-expanded','false');
    btn.innerHTML = '<span></span><span></span><span></span>';
    wrap.appendChild(btn);

    // Drawer con los mismos links del nav
    var drawer = document.createElement('div');
    drawer.className = 'mobile-drawer';
    Array.prototype.forEach.call(nav.querySelectorAll('a'), function(a){
      var link = document.createElement('a');
      link.href = a.getAttribute('href');
      link.textContent = a.textContent.trim();
      if(a.classList.contains('active')) link.classList.add('active');
      link.addEventListener('click', close);
      drawer.appendChild(link);
    });
    // Añadir enlace CTA al final del drawer
    var cta = header.querySelector('.cta');
    if(cta){
      var ctaLink = document.createElement('a');
      ctaLink.href = cta.getAttribute('href');
      ctaLink.textContent = cta.textContent.trim() || 'Escribinos';
      ctaLink.style.background = 'var(--green)';
      ctaLink.style.color = 'var(--cream)';
      ctaLink.style.textAlign = 'center';
      ctaLink.style.marginTop = '4px';
      ctaLink.addEventListener('click', close);
      drawer.appendChild(ctaLink);
    }
    header.appendChild(drawer);

    function open(){ drawer.classList.add('is-open'); btn.setAttribute('aria-expanded','true'); }
    function close(){ drawer.classList.remove('is-open'); btn.setAttribute('aria-expanded','false'); }
    btn.addEventListener('click', function(){
      if(drawer.classList.contains('is-open')) close(); else open();
    });
    document.addEventListener('click', function(e){
      if(!drawer.classList.contains('is-open')) return;
      if(header.contains(e.target)) return;
      close();
    });
  }
  if(document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
