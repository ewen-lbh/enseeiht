import java.util.Observable;
import java.util.Observer;
import javax.swing.JTextArea;

public class VueChatFenetre implements Observer {

  JTextArea messagesArea;

  VueChatFenetre(Chat chat) {
    super();
    this.messagesArea = new JTextArea();
  }

  @Override
  public void update(Observable o, Object arg) {
    if (arg instanceof MessageTexte) {
      MessageTexte msg = (MessageTexte) arg;
      messagesArea.append(msg.getPseudo() + ": " + msg.getTexte() + "\n");
    }
  }
}
