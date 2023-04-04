import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class ControleurChatFenetre {

  public JPanel inputArea;
  private JLabel username;
  private JTextField compose;
  private JPanel composeArea;
  private JButton send;
  private ControleurChat controller;

  public ControleurChatFenetre(Chat chat, String username) {
    this.controller = new ControleurChat(chat, username);
    this.inputArea = new JPanel();
    this.username = new JLabel(username);
    this.composeArea = new JPanel();
    this.compose = new JTextField();
    this.compose.setPreferredSize(new Dimension(300, 20));
    this.composeArea.add(compose);
    this.send = new JButton("OK");
    this.send.addActionListener(
        new ActionListener() {
          @Override
          public void actionPerformed(ActionEvent e) {
            ControleurChatFenetre.this.controller.ajouter(
                ControleurChatFenetre.this.compose.getText()
              );
            ControleurChatFenetre.this.compose.setText("");
          }
        }
      );
    this.inputArea.add(this.username, BorderLayout.WEST);
    this.inputArea.add(this.composeArea, BorderLayout.CENTER);
    this.inputArea.add(this.send, BorderLayout.EAST);
  }
}
