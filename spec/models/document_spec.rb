require 'rails_helper'

RSpec.describe Document, type: :model do
  it 'will be valid with valid information' do
    document = Document.new(title: 'Test Document', link: 'www.google.com')
    expect(document).to be_valid
  end

  it 'will not be valid with a missing title' do
    document = Document.new(title: nil, link: 'www.google.com')
    expect(document).not_to be_valid
  end

  it 'will not be valid with an invalid title' do
    document = Document.new(title: '0' * 65, link: 'www.google.com')
    expect(document).not_to be_valid
  end

  it 'will not be valid with a missing link' do
    document = Document.new(title: 'Test Document', link: nil)
    expect(document).not_to be_valid
  end

  it 'will not be valid with an invalid link' do
    document = Document.new(title: 'Test Document', link: '0' * 65)
    expect(document).not_to be_valid
  end
end
