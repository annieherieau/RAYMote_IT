document.addEventListener('DOMContentLoaded', function() {
    var stars = document.querySelectorAll('.star, .star_to_rate');
    var ratingField = document.getElementById('rating_field');
    var currentRating = ratingField ? parseInt(ratingField.value, 10) : 0;

    function updateStars(rating) {
        stars.forEach(function(star, index) {
            star.classList.toggle('rated', index < rating);
        });
    }

    function handleStarInteraction(event, index) {
        var rating = index + 1;
        if (ratingField) ratingField.value = rating;
        currentRating = rating;
        updateStars(rating);

        if (event.type === 'click') {
            var formUrl = this.getAttribute('data-form-url');
            if (formUrl) window.location.href = formUrl;
        }
    }

    stars.forEach(function(star, index) {
        ['click', 'mouseover'].forEach(function(eventType) {
            star.addEventListener(eventType, function(event) {
                handleStarInteraction.call(this, event, index);
            });
        });
    });

    var starRatingContainer = document.querySelector('.star-rating');
    if (starRatingContainer) {
        starRatingContainer.addEventListener('mouseleave', function() {
            updateStars(currentRating);
        });
    }

    if (!isNaN(currentRating) && currentRating > 0) {
        updateStars(currentRating);
    }
});