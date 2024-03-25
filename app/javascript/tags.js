document.addEventListener("DOMContentLoaded", function() {
    let newTags = [];
    const tagInput = document.getElementById('tag-input');
    const form = document.querySelector('form.form');
    const tagList = document.getElementById('tag-list');
  
    // Ajout de nouveaux tags
    if (tagInput) {
      tagInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && tagInput.value.trim() !== '') {
          e.preventDefault();
          const tagName = tagInput.value.trim();
          newTags.push(tagName); // Stocke le nouveau tag
    
          // Crée et ajoute le badge Bootstrap pour le nouveau tag
          const newTag = document.createElement('span');
          newTag.textContent = tagName;
          newTag.classList.add('badge', 'bg-primary');
          tagList.appendChild(newTag);
    
          tagInput.value = ''; // Réinitialise le champ d'entrée
        }
      });
    }
    
  
    // Soumission du formulaire
    if (form) {
      form.addEventListener('submit', function(e) {
        newTags.forEach(tagName => {
          const hiddenInput = document.createElement('input');
          hiddenInput.type = 'hidden';
          hiddenInput.name = 'workshop[tag_names][]';
          hiddenInput.value = tagName;
          form.appendChild(hiddenInput);
        });
      });
    }
  
    // Gestion des clics pour la suppression des tags
    if (tagList) {
      tagList.addEventListener('click', function(e) {
        if (e.target.classList.contains('remove-tag')) {
          e.preventDefault();
          const tagElement = e.target.closest('.destroyable');
          const tagId = e.target.getAttribute('data-tag-id');
    
          // Crée un champ caché pour marquer le tag comme supprimé
          const hiddenInputForDeletion = document.createElement('input');
          hiddenInputForDeletion.type = 'hidden';
          hiddenInputForDeletion.name = 'workshop[deleted_tag_ids][]';
          hiddenInputForDeletion.value = tagId;
          form.appendChild(hiddenInputForDeletion);
    
          tagElement.remove(); // Supprime visuellement l'étiquette du tag
        }
      });
    }
  });
  