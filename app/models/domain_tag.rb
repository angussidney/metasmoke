# frozen_string_literal: true

class DomainTag < ApplicationRecord
  has_and_belongs_to_many :spam_domains
end