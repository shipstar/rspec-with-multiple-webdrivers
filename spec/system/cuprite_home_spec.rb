require "rails_helper"

describe "CupriteHome", type: :system do
  it "loads the home page" do
    visit root_path

    expect(page).to have_text("This is a test.")
  end
end