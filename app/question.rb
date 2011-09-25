class Question < ActiveRecord::Base
  belongs_to :game

  validates :game,    :presence => true
  validates :kind,    :presence => true
  validates :content, :presence => true
  validates :number,  :presence => true, :uniqueness => { :scope => :scope }
end
