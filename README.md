# Overview

This repository reproduces a minimal set of conditions that caused the Rails test runner to hang if there are multiple webdrivers configured, but using RSpec instead. A high-level overview of the setup:

- cuprite + selenium
- RSpec system + feature specs
- Postgres

I added the following config block to `spec/rails_helper.rb`:

```ruby
config.before(type: :system) do
  driven_by :cuprite, using: :chromium, screen_size: [1400, 1400]
end

config.before(type: :system, driver: :selenium) do
  driven_by :selenium_headless, using: :chromium, screen_size: [1400, 1400]
end

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, browser: :chrome)
end

Capybara.register_driver(:selenium_headless) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome("goog:loggingPrefs" => {browser: "ALL"})
  browser_options = Selenium::WebDriver::Chrome::Options.new(args: ["--headless"])

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [capabilities, browser_options])
end

config.before(type: :feature) do
  Capybara.current_driver = :cuprite
end

config.before(type: :feature, driver: :selenium_headless) do
  Capybara.current_driver = :selenium_headless
end

config.after(type: :feature) do
  Capybara.use_default_driver
end
```

I made a `HomeController` with a simple 2-sentence `show` view. I then wrote two RSpec system/feature specs that visit that home page - one using Cuprite (the default) and one using Selenium (tagged with `driver: :selenium_headless` per above).

The tests run and pass, but still hang at the end despite switching the test runner:

![](docs/hanging.gif)

The companion repository using the Rails test runner is [here](https://github.com/shipstar/system-tests-with-multiple-webdrivers).