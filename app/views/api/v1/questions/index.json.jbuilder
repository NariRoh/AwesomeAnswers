# action.output.template_language
# index.json.jbuilder

json.more_questions @more_questions

# this generates a JSON array as the main element
# json.array! @questions do |question|
json.questions @questions do |question|
  json.id question.id
  # json.title will generate a key called `title` in an object within the main
  # array. The value will be `@question.title`
  json.title question.title
  # https://ruby-doc.org/core-2.2.0/Time.html
  json.created_on question.created_at.strftime('%Y-%B-%d')

  json.url api_v1_question_path(question)
end
