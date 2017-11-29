require 'test_helper'

class FilterMedicaidClinicsTest < ActionDispatch::IntegrationTest
  before do
    Capybara.current_driver = :poltergeist
    @user = create :user, role: :cm
    @medicaid_clinic = create :clinic, name: 'Medicaid Accepted', accepts_medicaid: true
    @non_medicaid_clinic = create :clinic, name: 'No Medicaid here', accepts_medicaid: false
    @patient = create :patient
    log_in_as @user
    visit edit_patient_path @patient
    has_text? 'First and last name' # wait until page loads
    click_link 'Abortion Information'
  end

  describe 'filtering to just Medicaid clinics' do
    it 'should filter to only Medicaid clinics when box is checked' do
      assert has_select? 'patient_clinic_id', with_options: [@medicaid_clinic.name,
                                                             @non_medicaid_clinic.name]

      check 'medicaid_filter'
      sleep 1
      options_with_filter = find('#patient_clinic_id').all('option')
                                                      .map { |opt| { name: opt.text, disabled: opt['disabled'] } }

      assert options_with_filter.find { |x| x[:name] == @non_medicaid_clinic.name }[:disabled] == true
      assert options_with_filter.find { |x| x[:name] == @medicaid_clinic.name }[:disabled] == false

      # try to select and watch it not work
      select @non_medicaid_clinic.name, from: 'patient_clinic_id'
      assert_equal '', find('#patient_clinic_id').value
    end
  end
end
