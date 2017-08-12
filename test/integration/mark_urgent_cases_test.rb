require 'application_system_test_case'

class MarkUrgentCasesTest < ApplicationSystemTestCase
  before do
    @user = create :user
    log_in_as @user
    @patient = create :patient
    visit edit_patient_path(@patient)
    click_link 'Notes'
  end

  it 'should initially show an empty checkbox' do
    refute page.has_checked_field?('patient_urgent_flag')
  end

  it 'should move the case to urgent after checking the checkbox' do
    check 'patient_urgent_flag'
    visit dashboard_path
    within :css, '#urgent_patients' do
      assert has_text? @patient.name
    end
  end
end
