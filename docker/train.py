import os
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer, Trainer, TrainingArguments
from datasets import load_dataset
from transformers import DataCollatorForLanguageModeling


model_name = "gpt2"  # You can replace this with another model (e.g., "bert-base-uncased")
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
model = GPT2LMHeadModel.from_pretrained(model_name)


dataset = load_dataset("wikitext", "wikitext-103-raw-v1")


def tokenize_function(examples):
    return tokenizer(examples["text"], return_tensors="pt", truncation=True, padding="max_length", max_length=512)

tokenized_datasets = dataset.map(tokenize_function, batched=True, remove_columns=["text"])


data_collator = DataCollatorForLanguageModeling(
    tokenizer=tokenizer,
    mlm=False
)

# Training arguments
training_args = TrainingArguments(
    output_dir="./results",
    overwrite_output_dir=True,
    num_train_epochs=3,
    per_device_train_batch_size=4,
    per_device_eval_batch_size=8,
    save_steps=10_000,
    save_total_limit=2,
    logging_dir="./logs",
    logging_steps=500,
    do_train=True,
    do_eval=True,
    evaluation_strategy="steps",
    eval_steps=500,
    learning_rate=5e-5,
    weight_decay=0.01,
    warmup_steps=1_000,
    logging_first_step=True,
)

trainer = Trainer(
    model=model,
    args=training_args,
    data_collator=data_collator,
    train_dataset=tokenized_datasets["train"],
    eval_dataset=tokenized_datasets["test"],
)

trainer.train()

trainer.save_model("./fine_tuned_model")
tokenizer.save_pretrained("./fine_tuned_model")

print("Training complete and model saved!")