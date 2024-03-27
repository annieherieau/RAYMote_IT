class CourseItem < ApplicationRecord
  belongs_to :workshop
  validate :link_is_valid_content_type

  private

  def link_is_valid_content_type
    return if link.blank?

    uri = URI.parse(link)

    def link_is_valid_content_type
      # Vérifie si l'URL termine par .pdf
      if link =~ /\.pdf\z/i
        # C'est probablement un lien PDF
      elsif link =~ /\Ahttps?:\/\/(www\.)?youtube\.com\/watch\?v=[\w-]+\z/i || link =~ /\Ahttps?:\/\/(www\.)?vimeo\.com\/\d+\z/i
        # C'est probablement un lien YouTube ou Vimeo
      elsif link =~ /\Ahttps?:\/\/+/i
        # C'est probablement un lien général vers un site web
      else
        errors.add(:link, 'doit conduire à un PDF, une vidéo YouTube/Vimeo ou un site Web valide')
      end
    end
  end
end
