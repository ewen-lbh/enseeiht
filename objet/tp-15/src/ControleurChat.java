public class ControleurChat {

  private Chat chat;
  private String username;

  public ControleurChat(Chat chat, String username) {
    this.chat = chat;
    this.username = username;
  }

  public void ajouter(String message) {
    this.chat.ajouter(new MessageTexte(username, message));
  }
}
