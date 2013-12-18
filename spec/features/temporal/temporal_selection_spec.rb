# EDSC-15 As a user, I want to search for datasets by simple temporal date 
#         range so that I may limit my results the relevant time span

require "spec_helper"

describe "Temporal" do
  before do
    visit "/"
  end

  context "range selection" do
    it "selects only start datetime" do
      script = "edsc.models.searchModel.query.temporal_start('2013-12-01T00:00:00Z')"
      page.evaluate_script(script)

      expect(page).to have_no_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_content("2000 Pilot Environmental Sustainability Index")
    end

    it "selects both start and stop datetime" do
      script = "edsc.models.searchModel.query.temporal_start('1975-12-01T00:00:00Z')"
      page.evaluate_script(script)
      script = "edsc.models.searchModel.query.temporal_stop('1975-12-01T00:00:00Z')"
      page.evaluate_script(script)

      expect(page).to have_no_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_no_content("2000 Pilot Environmental Sustainability Index")
      expect(page).to have_content("A Global Database of Carbon and Nutrient Concentrations of Green and Senesced Leaves")
    end

    it "clears the stop datetime" do
      script = "edsc.models.searchModel.query.temporal_start('1978-12-01T00:00:00Z')"
      page.evaluate_script(script)
      script = "edsc.models.searchModel.query.temporal_stop('1979-12-01T00:00:00Z')"
      page.evaluate_script(script)

      expect(page).to have_no_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_no_content("2001 Environmental Sustainability Index (ESI)")
      expect(page).to have_content("2000 Pilot Environmental Sustainability Index")

      page.find(".temporal-dropdown-button").hover
      find_by_id("clear_temporal_stop").click

      expect(page).to have_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_content("2001 Environmental Sustainability Index (ESI)")
      expect(page).to have_content("2000 Pilot Environmental Sustainability Index")
    end

    it "clears both start and stop datetime" do
      script = "edsc.models.searchModel.query.temporal_start('1978-12-01T00:00:00Z')"
      page.evaluate_script(script)
      script = "edsc.models.searchModel.query.temporal_stop('1979-12-01T00:00:00Z')"
      page.evaluate_script(script)

      expect(page).to have_no_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_no_content("2001 Environmental Sustainability Index (ESI)")
      expect(page).to have_content("2000 Pilot Environmental Sustainability Index")

      page.find(".temporal-dropdown-button").hover
      page.find_by_id("clear_temporal_start").click
      page.find_by_id("clear_temporal_stop").click

      expect(page).to have_content("15 Minute Stream Flow Data: USGS")
      expect(page).to have_content("2001 Environmental Sustainability Index (ESI)")
      expect(page).to have_content("2000 Pilot Environmental Sustainability Index")
    end

  end
end