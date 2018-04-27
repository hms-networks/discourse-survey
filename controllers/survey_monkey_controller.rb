class ::SurveymonkeyController < ::ApplicationController
  def send_survey
    topic_id = params[:topic_id]
    solved_topic = Topic.find_by(id: topic_id)
    original_poster = User.find_by(id: solved_topic.user_id)
    survey = SiteSetting.survey_monkey_survey_url.to_s
    url = survey.sub('%{topic_id}', solved_topic.id.to_s)
    SurveyMail::Survey.new.execute(template: 'survey_monkey', to_address: original_poster.email, survey: url)
    solved_topic.custom_fields["survey_sent"] = true;
    solved_topic.save!
  end
end
