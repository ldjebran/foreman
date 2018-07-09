require 'test_helper'

class Api::V2::MediaControllerTest < ActionController::TestCase
  setup do
    @new_medium = {
      :name => "new medium",
      :path => "http://www.newmedium.com/",
      :organization_ids => [Organization.first.id]
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media)
    medium = ActiveSupport::JSON.decode(@response.body)
    assert !medium.empty?
  end

  test "should show medium" do
    get :show, params: { :id => media(:one).to_param }
    assert_not_nil assigns(:medium)
    assert_response :success
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert !show_response.empty?
  end

  test_attributes :pid => '892b44d5-0f11-4e9d-8ee9-fd5abe0b0a9b'
  test "should create medium with valid name" do
    assert_difference('Medium.unscoped.count') do
      post :create, params: { :medium => @new_medium }
    end
    assert_response :created
    assert_equal @new_medium[:name], JSON.parse(@response.body)["name"], "Can't create media with valid name #{@new_medium[:name]}"
  end

  test_attributes :pid => '7885e205-6189-4e71-a6ee-e5ddb077ecee'
  test "should create medium with os family" do
    os_family = Operatingsystem.families.sample
    medium_os_family = @new_medium.clone.update(:os_family => os_family)
    post :create, params: { :medium => medium_os_family }
    assert_response :created
    assert_equal os_family, JSON.parse(@response.body)["os_family"], "Can't create media with valid os family #{os_family}"
  end

  test "should create medium with location" do
    location = Location.first
    medium_location = @new_medium.clone.update(:location_ids => [location.id])
    post :create, params: { :medium => medium_location }
    assert_response :created
    assert_equal location.name, JSON.parse(@response.body)["locations"][0]["name"], "Can't create media with valid location #{location}"
  end

  test "should create medium with os" do
    os = Operatingsystem.first
    medium_os = @new_medium.clone.update(:operatingsystem_ids => [os.id])
    post :create, params: { :medium => medium_os }
    assert_response :created
    assert_equal os.name, JSON.parse(@response.body)["operatingsystems"][0]["name"], "Can't create media with valid os #{os}"
  end

  test_attributes :pid => '0934f4dc-f674-40fe-a639-035761139c83'
  test "should not create with invalid name" do
    name = ""
    media_invalid_name = @new_medium.clone.update(:name => name)
    post :create, params: { :medium => media_invalid_name }
    assert_response :unprocessable_entity, "Can create media with invalid name #{name}"
  end

  test_attributes :pid => 'ae00b6bb-37ed-459e-b9f7-acc92ed0b262'
  test "should not create with invalid url" do
    path = RFauxFactory.gen_alpha
    media_invalid_url = @new_medium.clone.update(:path => path)
    post :create, params: { :medium => media_invalid_url }
    assert_response :unprocessable_entity, "Can create media with invalid url #{path}"
  end

  test_attributes :pid => '368b7eac-8c52-4071-89c0-1946d7101291'
  test "should not create with invalid os family" do
    os_family = RFauxFactory.gen_alpha
    media_invalid_os_family = @new_medium.clone.update(:os_family => os_family)
    post :create, params: { :medium => media_invalid_os_family }
    assert_response :unprocessable_entity, "Can create media with invalid os_family #{os_family}"
  end

  test_attributes :pid => 'a99c3c27-ad0a-474f-ad80-cb61022618a9'
  test "should update with valid name" do
    name = RFauxFactory.gen_alpha
    put :update, params: { :id => Medium.first.id, :name => name }
    assert_response :success
    assert_equal name, JSON.parse(@response.body)["name"], "Can't update media with valid name #{name}"
  end

  test "should update with valid url" do
    path = "http://www.example.com/"
    put :update, params: { :id => Medium.first.id, :path => path }
    assert_response :success
    assert_equal path, JSON.parse(@response.body)["path"], "Can't update media with valid url #{path}"
  end

  test_attributes :pid => '4daca3f4-39c9-43ec-92f2-a1e506147d71'
  test "should update with valid os family" do
    os_family = Operatingsystem.families.sample
    put :update, params: { :id => Medium.first.id, :os_family => os_family }
    assert_response :success
    assert_equal os_family, JSON.parse(@response.body)["os_family"], "Can't update media with valid os family #{os_family}"
  end

  test_attributes :pid => '1c7d3af1-8cef-454e-80b6-a8e95b5dfa8b'
  test "should not update with invalid name" do
    name = ""
    put :update, params: { :id => Medium.first.id, :medium => { :name => name } }
    assert_response :unprocessable_entity, "Can update media with invalid name #{name}"
  end

  test_attributes :pid => '6832f178-4adc-4bb1-957d-0d8d4fd8d9cd'
  test "should not update with invalid url" do
    path = RFauxFactory.gen_alpha
    put :update, params: { :id => Medium.first.id, :medium => { :path => path } }
    assert_response :unprocessable_entity, "Can update media with invalid path #{path}"
  end

  test_attributes :pid => 'f4c5438d-5f98-40b1-9bc7-c0741e81303a'
  test "should not update with invalid os family" do
    os_family = RFauxFactory.gen_alpha
    put :update, params: { :id => Medium.first.id, :medium => { :os_family => os_family } }
    assert_response :unprocessable_entity, "Can update media with invalid os family #{os_family}"
  end

  test_attributes :pid => '178c8ee2-2f69-41df-a604-e8a9e6c396ab'
  test "should destroy medium" do
    assert_difference('Medium.unscoped.count', -1) do
      delete :destroy, params: { :id => media(:unused).id.to_param }
    end
    assert_response :success
  end
end
