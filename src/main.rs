use iced::highlighter;
use iced::widget::text_editor;
use iced::{Element, Task, Theme};

fn main() -> iced::Result {
    iced::application("text_editor", Editor::update, Editor::view)
        .theme(Editor::theme)
        .run_with(Editor::new)
}

struct Editor {
    theme: highlighter::Theme,
    content: text_editor::Content,
}

#[derive(Debug, Clone)]
enum Message {
    Edit(text_editor::Action),
}

impl Editor {
    fn new() -> (Self, Task<Message>) {
        (
            Self {
                theme: highlighter::Theme::SolarizedDark,
                content: text_editor::Content::new(),
            },
            Task::none(),
        )
    }

    fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::Edit(action) => {
                self.content.perform(action);
                Task::none()
            }
        }
    }

    fn view(&self) -> Element<Message> {
        let input = text_editor(&self.content);
        input.into()
    }

    fn theme(&self) -> Theme {
        if self.theme.is_dark() {
            Theme::Dark
        } else {
            Theme::Light
        }
    }
}
