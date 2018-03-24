package info.yish.sty.net;

import java.io.IOException;
import java.util.logging.FileHandler;

public class Control {

	public static void main(String[] args) throws SecurityException, IOException {
		String hostname = null; // "10.100.231.38";
		String transfertype = null; // "FTP or SFTP";
		String username = null; // "root";
		String password = null; // "abc123";
		String remtePath = null; // "/tmp/Geo";
		String privateKey = null; // "id_rsa"
		String passphrase = null; // "null"
		boolean asciiTransMode; // "true or false";
		String[] files = null; // new String[]{"out0.log"};

		boolean isLogin = false;

		// Check args: hostname, transfertype username, password,
		// remtePath,files
		if (args.length < 7) {
			System.out.println(
					"Please see usage : java -jar ftpClientTool.jar 10.100.231.111 ftp root 111111 /tmp false out1.dat out2.dat ");
			return;
		} else {
			hostname = args[0];
			transfertype = args[1];
			username = args[2];
			password = args[3];
			remtePath = args[4];
			asciiTransMode = Boolean.valueOf(args[5]).booleanValue();

			files = new String[args.length - 6];
			for (int i = 6; i < args.length; i++) {
				files[i - 6] = args[i];
			}

			// ftp login
			if ("ftp".equals(transfertype) || "FTP".equals(transfertype)) {

				FTPTool instance = new FTPTool();
				instance.getLogger().addHandler(new FileHandler("ftpLog.txt"));
				instance.upload(hostname, username, password, remtePath, asciiTransMode, files);

				// sftp login
			} else if ("sftp".equals(transfertype) || "SFTP".equals(transfertype)) {

				SFTPTool instance = new SFTPTool();
				instance.getLogger().addHandler(new FileHandler("ftpLog.txt"));

				// sftp secretKey login
				if (password.indexOf("-") != -1) {

					String[] secretKey = password.split("-");
					privateKey = secretKey[0];
					passphrase = secretKey[1];
					isLogin = instance.connectRSA(hostname, username, privateKey, passphrase);
					if (!isLogin) {
						return;
					}

				} else {
					// sftp password login
					isLogin = instance.connect(hostname, username, password);
					if (!isLogin) {
						return;
					}
				}
				// uploadFile
				instance.uploadFile(remtePath, files);

			} else {
				// no ftp or sftp
				System.out.println(
						"Please see usage : java -jar ftpClientTool.jar 10.100.231.111 ftp root 111111 /tmp false out1.dat out2.dat ");
				return;

			}
		}

		System.exit(0);

	}

}
