require "test_helper"

class MailingCampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mailing_campaign = mailing_campaigns(:one)
  end

  test "should get index" do
    get mailing_campaigns_url, as: :json
    assert_response :success
  end

  test "should create mailing_campaign" do
    assert_difference("MailingCampaign.count") do
      post mailing_campaigns_url, params: { mailing_campaign: { name: @mailing_campaign.name, sent_at: @mailing_campaign.sent_at, status: @mailing_campaign.status, subject: @mailing_campaign.subject, target_audience: @mailing_campaign.target_audience } }, as: :json
    end

    assert_response :created
  end

  test "should show mailing_campaign" do
    get mailing_campaign_url(@mailing_campaign), as: :json
    assert_response :success
  end

  test "should update mailing_campaign" do
    patch mailing_campaign_url(@mailing_campaign), params: { mailing_campaign: { name: @mailing_campaign.name, sent_at: @mailing_campaign.sent_at, status: @mailing_campaign.status, subject: @mailing_campaign.subject, target_audience: @mailing_campaign.target_audience } }, as: :json
    assert_response :success
  end

  test "should destroy mailing_campaign" do
    assert_difference("MailingCampaign.count", -1) do
      delete mailing_campaign_url(@mailing_campaign), as: :json
    end

    assert_response :no_content
  end
end
