public class ChatSwing {

  public static void main(String[] args) {
    Chat chat = new Chat();
    VueChat vue = new VueChat(chat, "toto");
    ConsoleListener console = new ConsoleListener();
    chat.addObserver(console);
    chat.ajouter(new MessageTexte("toto", "Bonjour"));
    chat.ajouter(new MessageTexte("titi", "Salut"));
    chat.ajouter(new MessageTexte("toto", "Ca va ?"));
  }
}
