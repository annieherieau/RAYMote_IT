document.addEventListener('DOMContentLoaded', function() {
    var stars = document.querySelectorAll('.star, .star_to_rate');
    var ratingField = document.getElementById('rating_field');
    var currentRating = ratingField ? parseInt(ratingField.value, 10) : 0;

    function updateStars(rating, temporaryUpdate = false) {
        stars.forEach(function(star, index) {
            star.classList.toggle('rated', index < rating);
        });

        // Mettre à jour la note seulement lors d'un clic, pas lors d'un survol
        if (!temporaryUpdate && ratingField) ratingField.value = rating;
    }

    stars.forEach(function(star, index) {
        // Événement de clic pour mettre à jour la note de façon permanente
        star.addEventListener('click', function() {
            currentRating = index + 1;
            updateStars(currentRating);

            var formUrl = this.getAttribute('data-form-url');
            if (formUrl) window.location.href = formUrl;
        });

        // Événement de survol pour mettre à jour la note de façon temporaire
        star.addEventListener('mouseover', function() {
            updateStars(index + 1, true);
        });
    });

    // Réinitialiser les étoiles à la note actuelle lorsque la souris quitte la zone des étoiles
    var starRatingContainer = document.querySelector('.star-rating');
    if (starRatingContainer) {
        starRatingContainer.addEventListener('mouseleave', function() {
            updateStars(currentRating);
        });
    }

    // Pré-sélectionner les étoiles en fonction de la note actuelle
    if (!isNaN(currentRating) && currentRating > 0) {
        updateStars(currentRating);
    }
});