require "rails_helper"

describe "CupriteHome", type: :feature do
  it "loads the home page" do
    puts page.driver.class

    visit root_path

    expect(page).to have_text("This is a test.")
  end
end