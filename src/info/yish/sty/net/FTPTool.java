package info.yish.sty.net;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.logging.Logger;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

public class FTPTool {

	private Logger logger = Logger.getLogger(getClass().getName());

	public String upload(String hostname, String username, String password, String remtePath, boolean asciiTransMode,
			String... files) {

		FTPClient client = new FTPClient();
		FileInputStream fis = null;
		int port = 21;
		String resultMsg = "";
		String tempMsg = "";
		File tempFile = null;
		String newFileName = null;
		StringBuffer finalFiles = new StringBuffer();

		try {
			client.connect(hostname, port);
			boolean isLogin = client.login(username, password);
			if (!isLogin) {
				client.logout();
				resultMsg = "LOGIN ERROR !";
				System.out.println(resultMsg);
				return resultMsg;
			}
			client.sendNoOp();
			int replyCode = client.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				client.disconnect();
				resultMsg = "Connection ERROR !";
				System.out.println(resultMsg);
				return resultMsg;
			}

			System.out.println("FTP connected to " + hostname + ":" + port + ".");
			logger.info("FTP connected to " + hostname + " : " + port + ".");

			client.changeWorkingDirectory(remtePath);
			replyCode = client.getReplyCode();
			if (replyCode == 550) {
				client.makeDirectory(remtePath);
				client.changeWorkingDirectory(remtePath);
			}

			if (asciiTransMode) {
				client.setFileTransferMode(FTP.ASCII_FILE_TYPE);
			}

			client.setControlKeepAliveReplyTimeout(120);
			client.enterLocalPassiveMode();

			for (String filename : files) {
				logger.info("...Begin to upload file : " + filename);

				tempFile = new File(filename.trim());
				if (tempFile.exists() && tempFile.isFile()) {
					long start = System.currentTimeMillis();

					newFileName = tempFile.getName();
					fis = new FileInputStream(tempFile);  
					boolean isFileStored = false;
					 OutputStream outputStream = client.storeFileStream(filename);
					 
					byte[] bytes = new byte[512];
	                int read = 0;
	                while ((read = fis.read(bytes)) != -1) {
	                    outputStream.write(bytes, 0, read);
	                }
	               
	                fis.close();
	                outputStream.close();
	                finalFiles.append(newFileName + " ");
	                isFileStored = client.completePendingCommand();
					long end = System.currentTimeMillis();

					System.out.println("...Reply Code : " + client.getReplyCode());
					System.out.println("...Bytes length : " + tempFile.length());
					System.out.print("...ReplyMessage : " + client.getReplyString());
					System.out.println("...Take of time : " + (end - start) + " (in miniseconds), "
							+ (end - start) / 60000 + " (in minuts)\n");

					logger.info("...End of file upload: " + filename + ", isFileStored:  " + isFileStored
							+ ", and take of time: " + (end - start) + " (in miniseconds), " + (end - start) / 60000
							+ " (in minuts)");

				} else {
					tempMsg = "FTP error : The system can't find the specified file. " + filename;
					System.out.println(tempMsg);
					logger.info(tempMsg);
					continue;
				}
			}

			client.logout();
			resultMsg = "FTP upload successfully : " + finalFiles.toString();
		} catch (Exception ie) {
			resultMsg = "FTP error : " + ie.getMessage();
			System.out.println(resultMsg);
			ie.printStackTrace();
		} finally {
			try {
				if (fis != null) {
					fis.close();
				}
				client.disconnect();
			} catch (Exception e) {
				System.out.println("FTP disconnect exception");
				e.printStackTrace();
			}
		}

		System.out.println(resultMsg);
		System.out.println();
		return resultMsg;
	}
	
	public String uploadB(String hostname, String username, String password, String remtePath, boolean asciiTransMode,
			String... files) {

		FTPClient client = new FTPClient();
		BufferedInputStream bis = null;
		int port = 21;
		String resultMsg = "";
		String tempMsg = "";
		File tempFile = null;
		String newFileName = null;
		StringBuffer finalFiles = new StringBuffer();

		try {
			client.connect(hostname, port);
			boolean isLogin = client.login(username, password);
			if (!isLogin) {
				client.logout();
				resultMsg = "LOGIN ERROR !";
				System.out.println(resultMsg);
				return resultMsg;
			}
			client.sendNoOp();
			int replyCode = client.getReplyCode();
			if (!FTPReply.isPositiveCompletion(replyCode)) {
				client.disconnect();
				resultMsg = "Connection ERROR !";
				System.out.println(resultMsg);
				return resultMsg;
			}

			System.out.println("FTP connected to " + hostname + ":" + port + ".");
			logger.info("FTP connected to " + hostname + " : " + port + ".");

			client.changeWorkingDirectory(remtePath);
			replyCode = client.getReplyCode();
			if (replyCode == 550) {
				client.makeDirectory(remtePath);
				client.changeWorkingDirectory(remtePath);
			}

			if (asciiTransMode) {
				client.setFileTransferMode(FTP.ASCII_FILE_TYPE);
			}

			client.setControlKeepAliveReplyTimeout(120);
			client.enterLocalPassiveMode();

			for (String filename : files) {
				logger.info("...Begin to upload file : " + filename);

				tempFile = new File(filename.trim());
				if (tempFile.exists() && tempFile.isFile()) {
					long start = System.currentTimeMillis();

					newFileName = tempFile.getName();
					bis = new BufferedInputStream(new FileInputStream(tempFile));
					boolean isFileStored = false;

					isFileStored = client.storeFile(newFileName, bis);
					finalFiles.append(newFileName + " ");
					bis.close();
					long end = System.currentTimeMillis();

					System.out.println("...Reply Code : " + client.getReplyCode());
					System.out.println("...Bytes length : " + tempFile.length());
					System.out.print("...ReplyMessage : " + client.getReplyString());
					System.out.println("...Take of time : " + (end - start) + " (in miniseconds), "
							+ (end - start) / 60000 + " (in minuts)\n");

					logger.info("...End of file upload: " + filename + ", isFileStored:  " + isFileStored
							+ ", and take of time: " + (end - start) + " (in miniseconds), " + (end - start) / 60000
							+ " (in minuts)");

				} else {
					tempMsg = "FTP error : The system can't find the specified file. " + filename;
					System.out.println(tempMsg);
					logger.info(tempMsg);
					continue;
				}
			}

			client.logout();
			resultMsg = "FTP upload successfully : " + finalFiles.toString();
		} catch (Exception ie) {
			resultMsg = "FTP error : " + ie.getMessage();
			System.out.println(resultMsg);
			ie.printStackTrace();
		} finally {
			try {
				if (bis != null) {
					bis.close();
				}
				client.disconnect();
			} catch (Exception e) {
				System.out.println("FTP disconnect exception");
				e.printStackTrace();
			}
		}

		System.out.println(resultMsg);
		System.out.println();
		return resultMsg;
	}

	public Logger getLogger() {
		return logger;
	}

}
