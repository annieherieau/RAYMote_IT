class Category < ApplicationRecord
    has_many :workshops
    has_one_attached :icon

    def default_icon
        url = 'app/assets/images/categories/default_icon.png'
        self.icon.attach(io: File.open(url), filename: url.split('/').last)
    end
end
