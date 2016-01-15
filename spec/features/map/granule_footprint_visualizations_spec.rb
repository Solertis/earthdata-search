# EDSC-86 As a user, I want to view polygon spatial extents on a map so that I
#         may understand the location and shape of my results
# EDSC-88 As a user, I want to view point spatial extents on a map so that I may
#         understand the location and shape of my results
# EDSC-90 As a user, I want to view rectangular spatial extents on a map so that
#         I may understand the location and shape of my results

require "spec_helper"

describe "Granule footprint visualizations", reset: false, wait: 60 do
  extend Helpers::CollectionHelpers

  before :all do
    load_page :search
  end

  context "for point collections" do
    use_collection 'C179003030-ORNL_DAAC', '15 Minute Stream Flow Data'

    context "visualizing a collection's granules" do
      hook_granule_results

      it "draws a single point on the map representing all of the collection's granules" do
        wait_for_xhr
        expect(page).to have_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end

      context "and mousing over a visualized granule" do
        before :all do
          map_mousemove('#map', 39.1, -96.6)
        end

        after :all do
          map_mouseout()
        end

        it "draws the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path')
        end
      end

      context "and mousing off of a visualized granule" do
        before :all do
          map_mousemove('#map', 39.1, -96.6)
          map_mouseout()
        end

        it "hides the granule's footprint" do
          expect(page).to have_no_selector('.leaflet-overlay-pane path')
        end
      end
    end

    context "removing a visualized collection" do
      hook_granule_results_back

      it "hides the collection's visualizations" do
        expect(page).to have_no_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end
    end
  end

  context "for polygon collections" do
    use_collection 'C1000000011-LANCEMODIS', 'MODIS/Terra Calibrated Radiances 5-Min L1B Swath 250m V005 NRT'

    before :all do
      create_bounding_box(0, 0, 15, 15)
      wait_for_xhr
    end

    context "visualizing a collection's granules" do
      hook_granule_results('MODIS/Terra Calibrated Radiances 5-Min L1B Swath 250m V005 NRT')

      it "draws polygons on the map for granule spatial areas" do
        wait_for_xhr
        expect(page).to have_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end

      context "and mousing over a visualized granule" do
        before :all do
          map_mousemove()
        end

        after :all do
          map_mouseout()
        end

        it "draws the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path', count: 3)
        end
      end

      context "and mousing off of a visualized granule" do
        before :all do
          map_mousemove()
          map_mouseout()
        end

        it "hides the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path', count: 1) # Just the spatial constraint
        end
      end
    end

    context "removing a visualized collection" do
      hook_granule_results_back('MODIS/Terra Calibrated Radiances 5-Min L1B Swath 250m V005 NRT')

      it "hides the collection's visualizations" do
        expect(page).to have_no_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end
    end
  end

  context "for line collections" do
    use_collection 'C5920490-LARC_ASDC', 'CAL_IIR_L2_Track-Beta-V3-01'

    context "visualizing a collection's granules" do
      hook_granule_results('CAL_IIR_L2_Track-Beta-V3-01')

      it "draws lines on the map for granule spatial areas" do
        wait_for_xhr
        expect(page).to have_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end

      context "and mousing over a visualized granule" do
        before :all do
          first_granule_list_item.trigger(:mouseover)
        end

        after :all do
          first_granule_list_item.trigger(:mouseout)
        end

        it "draws the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path')
        end
      end

      context "and mousing off of a visualized granule" do
        before :all do
          first_granule_list_item.trigger(:mouseover)
          first_granule_list_item.trigger(:mouseout)
        end

        it "hides the granule's footprint" do
          expect(page).to have_no_selector('.leaflet-overlay-pane path')
        end
      end
    end

    context "removing a visualized collection" do
      hook_granule_results_back('CAL_IIR_L2_Track-Beta-V3-01')

      it "hides the collection's visualizations" do
        expect(page).to have_no_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end
    end
  end

  context "for bounding box collections" do
    use_collection 'C204200619-GSFCS4PA', 'AIRS-CloudSat cloud mask and radar reflectivities collocation indexes V3.1'

    before :all do
      create_bounding_box(0, 0, 15, 15)
      wait_for_xhr
    end

    context "visualizing a collection's granules" do
      hook_granule_results('AIRS-CloudSat cloud mask and radar reflectivities collocation indexes V3.1')

      it "draws polygons on the map for granule spatial areas" do
        wait_for_xhr
        expect(page).to have_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end

      context "and mousing over a visualized granule" do
        before :all do
          map_mousemove()
        end

        after :all do
          map_mouseout()
        end

        it "draws the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path', count: 2)
        end
      end

      context "and mousing off of a visualized granule" do
        before :all do
          map_mousemove()
          map_mouseout()
        end

        it "hides the granule's footprint" do
          expect(page).to have_selector('.leaflet-overlay-pane path', count: 1) # Just the spatial constraint
        end
      end
    end

    context "removing a visualized collection" do
      hook_granule_results_back('AIRS-CloudSat cloud mask and radar reflectivities collocation indexes V3.1')

      it "hides the collection's visualizations" do
        expect(page).to have_no_selector('.leaflet-tile-pane .leaflet-layer:nth-child(2) canvas')
      end
    end
  end
end
