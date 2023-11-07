import java.net.*;
import java.io.*;
import java.util.Random;

public class LoadBalancer implements Runnable {
    static String hosts[] = { "localhost", "localhost" };
    static int ports[] = { 8081, 8082, 8083, 8084, 8085, 8086, 8087, 8088, 8089, 8091, 8092, 8093, 8094, 8095, 8096,
            8097, 8098, 8099 };
    static String uids[] = { "net7", "tvn7", "photo", "animation", "7fault" };

    static int nbHosts() {
        return LoadBalancer.ports.length;
    }

    private Socket socket;

    public LoadBalancer(Socket socket) {
        this.socket = socket;
    }

    static Random rand = new Random();

    private int randomPort() {
        return ports[rand.nextInt(nbHosts())];
    }

    public static void main(String[] args) throws IOException {
        ServerSocket server = new ServerSocket(8080);
        while (true) {
            new Thread(new LoadBalancer(server.accept())).start();
        }

    }

    public void run() {
        try {
            System.out.println("got request");
            InputStreamReader input = new InputStreamReader(socket.getInputStream());
            PrintStream out = new PrintStream(socket.getOutputStream());
            // int port = randomPort();
            String request = new LineNumberReader(input).readLine();
            if (!request.startsWith("GET ")) {
                out.println("HTTP/1.0 405 Method Not Allowed\n");
            }

            String uid = uids[rand.nextInt(uids.length)];
            // InputStream worker = new URL("http://localhost:" + port + request.replace("GET ", "")).openStream();
            InputStream worker = new URL("https://churros.inpt.fr/groups/" + uid + "-n7/").openStream();
            BufferedReader in = new BufferedReader(new InputStreamReader(worker));

            String inputLine;
            String output = "";
            while ((inputLine = in.readLine()) != null)
                output += inputLine + "\n";
            out.print("HTTP/1.0 200 OK\n\n" + output.replace("<body>", "<body><code>from uid @" + uid + "</code>"));
            System.out.println("finished writing request");
            out.close();
            in.close();
            input.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
