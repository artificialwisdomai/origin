import pykoi

model = pykoi.ModelFactory.create_model(
    model_source="huggingface",
    pretrained_model_name_or_path="/home/ubuntu/llama2/70B-chat",
)

database = pykoi.QuestionAnswerDatabase(debug=True)
chatbot = pykoi.Chatbot(model=model, feedback="vote")
dashboard = pykoi.Dashboard(database=database)

###
# Appearance of magic pushbutton.

app = pykoi.Application(debug=False, share=False, host="0.0.0.0", port=7080)
app.add_component(chatbot)
app.add_component(dashboard)
app.run()
