import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;

public class VueChat {

  private Chat chat;

  private JFrame container;
  private JButton close;
  private VueChatFenetre messages;
  private ControleurChatFenetre input;

  public VueChat(Chat chat, String username) {
    this.chat = chat;
    this.messages = new VueChatFenetre(chat);
    this.input = new ControleurChatFenetre(chat, username);
    this.close = new JButton("Fermer");
    this.close.addActionListener(
        new ActionListener() {
          @Override
          public void actionPerformed(ActionEvent e) {
            VueChat.this.container.dispose();
          }
        }
      );
    this.chat.addObserver(this.messages);

    this.container = new JFrame();
    this.container.add(this.close, BorderLayout.NORTH);
    this.container.add(this.messages.messagesArea, BorderLayout.CENTER);
    this.container.add(this.input.inputArea, BorderLayout.SOUTH);

    this.container.setMinimumSize(new Dimension(400, 600));
    this.container.pack();
    this.container.setVisible(true);
  }
}
