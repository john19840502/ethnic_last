class CollectionImage < ActiveRecord::Base
  has_attached_file :attachment,
                    styles: {icon: '64x64', small: '220x80>', medium: '220x320>', slider1: '440x640>', slider2: '440x320>' },
                    default_style: :medium

  validates :position, presence: true
  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment, content_type: ['image/png', 'image/jpeg']
end
