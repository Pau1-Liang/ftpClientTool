package info.yish.sty.net;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;
import java.util.logging.Logger;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

public class SFTPTool {

	private Logger logger = Logger.getLogger(getClass().getName());

	private int port = 22;
	private int retry = 3;
	private int timeout = 1000;
	private ChannelSftp sftp = null;
	private Session sshSession = null;

	// 密码连接服务器
	public boolean connect(String host, String username, String password) {

		String resultMsg = "";

		try {
			JSch jsch = new JSch();
			sshSession = jsch.getSession(username, host, port);
			sshSession.setPassword(password);
			Properties sshConfig = new Properties();
			sshConfig.put("StrictHostKeyChecking", "no");
			sshSession.setConfig(sshConfig);
			sshSession.setTimeout(timeout);
			sshSession.connect();
			Channel channel = sshSession.openChannel("sftp");
			channel.connect();
			sftp = (ChannelSftp) channel;
			System.out.println("SFTP use password connected to " + host + ":" + port + ".");
			logger.info("SFTP use password connected to " + host + " : " + port + ".");

		} catch (Exception e) {
			resultMsg = "SFTP error : " + e.getMessage();
			System.out.println(resultMsg);
			logger.info(resultMsg);
			e.printStackTrace();
			return false;
		}
		return true;
	}

	// 密钥连接服务器
	public boolean connectRSA(String host, String username, String privateKey, String passphrase) {

		String resultMsg = "";
		File file = null;
		try {
			JSch jsch = new JSch();

			if (privateKey != null && !"null".equals(privateKey) && !"".equals(privateKey)) {
				file = new File(privateKey);
				if (file.exists() && file.isFile()) {
					if (passphrase != null && !"null".equals(passphrase) && !"".equals(passphrase)) {
						jsch.addIdentity(privateKey, passphrase);
					} else {
						jsch.addIdentity(privateKey);
					}
				} else {
					resultMsg = "SFTP error : The system can't find the privateKey file(id_rsa). ";
					System.out.println(resultMsg);
					logger.info(resultMsg);
				}

			} else {
				file = new File("id_rsa");
				if (file.exists() && file.isFile()) {
					if (passphrase != null && !"null".equals(passphrase) && !"".equals(passphrase)) {
						jsch.addIdentity("id_rsa", passphrase);
					} else {
						jsch.addIdentity("id_rsa");
					}
				} else {
					resultMsg = "SFTP error : The system can't find the privateKey file(id_rsa). ";
					System.out.println(resultMsg);
					logger.info(resultMsg);
				}
			}

			sshSession = jsch.getSession(username, host, port);
			Properties sshConfig = new Properties();
			sshConfig.put("StrictHostKeyChecking", "no");
			sshSession.setConfig(sshConfig);
			sshSession.setTimeout(timeout);
			sshSession.connect();
			Channel channel = sshSession.openChannel("sftp");
			channel.connect();
			sftp = (ChannelSftp) channel;
			System.out.println("SFTP use secret key connected to " + host + ":" + port + ".");
			logger.info("SFTP use secret key connected to " + host + " : " + port + ".");

		} catch (Exception e) {
			resultMsg = "SFTP error : " + e.getMessage();
			System.out.println(resultMsg);
			logger.info(resultMsg);
			e.printStackTrace();
			return false;
		}
		return true;
	}

	// 关闭连接服务器
	public void disconnect() {
		if (this.sftp != null) {
			if (this.sftp.isConnected()) {
				this.sftp.disconnect();
				logger.info("sftp is closeed already.");
			}
		}

		if (this.sshSession != null) {
			if (this.sshSession.isConnected()) {
				this.sshSession.disconnect();
				logger.info("sshSession is closeed already.");
			}
		}
	}

	// 上传文件A
	public String uploadFileA(String remtePath, String[] files) {

		String resultMsg = "";
		String tempMsg = "";
		FileInputStream in = null;
		File tempFile = null;
		String newFileName = null;
		StringBuffer finalFiles = new StringBuffer();

		try {
			createDir(remtePath);
			for (String filename : files) {
				logger.info("...Begin to upload file : " + filename);

				tempFile = new File(filename.trim());
				if (tempFile.exists() && tempFile.isFile()) {

					long start = System.currentTimeMillis();
					newFileName = tempFile.getName();
					in = new FileInputStream(tempFile);
					sftp.put(in, newFileName);

					finalFiles.append(newFileName + " ");
					in.close();
					long end = System.currentTimeMillis();

					System.out.println("...Bytes length : " + tempFile.length());
					System.out.println("...Take of time : " + (end - start) + " (in miniseconds), "
							+ (end - start) / 60000 + " (in minuts)\n");

					logger.info("...End of file upload: " + filename + ", and take of time: " + (end - start)
							+ " (in miniseconds), " + (end - start) / 60000 + " (in minuts)");

				} else {
					tempMsg = "SFTP error : The system can't find the specified file. " + filename;
					System.out.println(tempMsg);
					logger.info(tempMsg);
					continue;
				}
			}

			resultMsg = "SFTP upload successfully : " + finalFiles.toString();

		} catch (Exception e) {
			resultMsg = "SFTP error : " + e.getMessage();
			System.out.println(resultMsg);
			e.printStackTrace();
		} finally {
			try {
				if (in != null) {
					in.close();
				}
				sftp.disconnect();
			} catch (IOException e) {
				System.out.println("SFTP disconnect exception");
				e.printStackTrace();
			}
		}

		System.out.println(resultMsg);
		System.out.println();
		return resultMsg;
	}

	// 上传文件,由于管带限制时候使用字节流
	public String uploadFile(String remtePath, String[] files) {
		String resultMsg = "";
		String tempMsg = "";
		FileInputStream in = null;
		OutputStream out = null;
		File tempFile = null;
		String newFileName = null;
		StringBuffer finalFiles = new StringBuffer();

		try {
			createDir(remtePath);
			for (String filename : files) {
				logger.info("...Begin to upload file : " + filename);

				tempFile = new File(filename.trim());
				if (tempFile.exists() && tempFile.isFile()) {

					long start = System.currentTimeMillis();
					newFileName = tempFile.getName();

					out = sftp.put(newFileName, ChannelSftp.OVERWRITE);
					byte[] buff = new byte[512];
					int read;
					if (out != null) {
						in = new FileInputStream(tempFile);
						do {
							read = in.read(buff, 0, buff.length);
							if (read > 0) {
								out.write(buff, 0, read);
							}
							out.flush();
						} while (read >= 0);
					}

					finalFiles.append(newFileName + " ");
					in.close();
					long end = System.currentTimeMillis();

					System.out.println("...Bytes length : " + tempFile.length());
					System.out.println("...Take of time : " + (end - start) + " (in miniseconds), "
							+ (end - start) / 60000 + " (in minuts)\n");

					logger.info("...End of file upload: " + filename + ", and take of time: " + (end - start)
							+ " (in miniseconds), " + (end - start) / 60000 + " (in minuts)");

				} else {
					tempMsg = "SFTP error : The system can't find the specified file. " + filename;
					System.out.println(tempMsg);
					logger.info(tempMsg);
					continue;
				}
			}

			resultMsg = "SFTP upload successfully : " + finalFiles.toString();

		} catch (Exception e) {
			resultMsg = "SFTP error : " + e.getMessage();
			System.out.println(resultMsg);
			e.printStackTrace();
		} finally {
			try {
				if (in != null) {
					in.close();
				}
				sftp.disconnect();
			} catch (IOException e) {
				System.out.println("SFTP disconnect exception");
				e.printStackTrace();
			}
		}

		System.out.println(resultMsg);
		System.out.println();
		return resultMsg;
	}

	// 创建目录
	public boolean createDir(String createpath) {
		try {
			if (isDirExist(createpath)) {
				this.sftp.cd(createpath);
				return true;
			}
			String pathArry[] = createpath.split("/");
			StringBuffer filePath = new StringBuffer("/");
			for (String path : pathArry) {
				if (path.equals("")) {
					continue;
				}
				filePath.append(path + "/");
				if (isDirExist(filePath.toString())) {
					sftp.cd(filePath.toString());
				} else {
					sftp.mkdir(filePath.toString());
					sftp.cd(filePath.toString());
				}
			}
			this.sftp.cd(createpath);
			return true;
		} catch (SftpException e) {
			e.printStackTrace();
		}
		return false;
	}

	// 判断目录是否存在
	private boolean isDirExist(String directory) {
		boolean isDirExistFlag = false;
		try {
			SftpATTRS sftpATTRS = sftp.lstat(directory);
			isDirExistFlag = true;
			return sftpATTRS.isDir();
		} catch (Exception e) {
			if (e.getMessage().toLowerCase().equals("no such file")) {
				isDirExistFlag = false;
			}
		}
		return isDirExistFlag;

	}

	public Logger getLogger() {
		return logger;
	}

	public void setLogger(Logger logger) {
		this.logger = logger;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public int getRetry() {
		return retry;
	}

	public void setRetry(int retry) {
		this.retry = retry;
	}

	public int getTimeout() {
		return timeout;
	}

	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}

	public ChannelSftp getSftp() {
		return sftp;
	}

	public void setSftp(ChannelSftp sftp) {
		this.sftp = sftp;
	}

	public Session getSshSession() {
		return sshSession;
	}

	public void setSshSession(Session sshSession) {
		this.sshSession = sshSession;
	}

}
