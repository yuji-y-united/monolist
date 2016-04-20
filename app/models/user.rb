class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items , through: :wants, source: :item
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item
  
  
  # itemをwantする
  def want(item)
      want_items.find_or_create_by(item_id: item.id)
  end
    
  # itemのwantを解除する
  def unwant(item)
      want_item = want_items.find_by(item_id: item.id)
      want_item.destroy if want_item
  end
    
  # あるitemをwantしているかどうか
  def want?(item)
      want_items.include?(item)
  end
  
  # itemをhaveする
  def have(item)
      have_items.find_or_create_by(item_id: item.id)
  end
    
  # itemのhaveを解除する
  def unhave(item)
      have_item = have_items.find_by(item_id: item.id)
      have_item.destroy if have_item
  end
    
  # あるitemをwantしているかどうか
  def have?(item)
      have_items.include?(item)
  end

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end
end
