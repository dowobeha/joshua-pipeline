import java.io.*;
import java.util.Scanner;
import java.util.regex.*;

public class Find {


	public static void main(String[] args) throws java.io.FileNotFoundException {

					// Set System.out and System.err to use the provided character encoding
		try {
						System.setOut(new PrintStream(System.out, true, "UTF-8"));
						System.setErr(new PrintStream(System.err, true, "UTF-8"));
				} catch (UnsupportedEncodingException e1) {
						System.err.println("UTF-8 is not a valid encoding; using system default encoding for System.out and System.err.");
				} catch (SecurityException e2) {
						System.err.println("Security manager is configured to disallow changes to System.out or System.err; using system default encoding.");
				}

	
		char ARABIC_LETTER_WAW = '\u0648';
		char NUMBER_SIGN = '\u0023';
		StringBuilder patternBuilder = new StringBuilder();
		patternBuilder.append(ARABIC_LETTER_WAW);
		patternBuilder.append(NUMBER_SIGN);
		String pattern = patternBuilder.toString();
		
		//Pattern p = Pattern.compile("^<seg id=.*> *\u0648\u0023");
		Pattern p = Pattern.compile(pattern);
		System.out.println("Looking for '"+ pattern + "'");
		
		for (String filename : args) {
			
			int lineCount = 0;
			int startsWith = 0;
			int contains = 0;
			Scanner scanner = new Scanner(new File(filename),"UTF8");
		
			while (scanner.hasNextLine()) {
		
				lineCount += 1;
				String line = scanner.nextLine();
			
				Matcher m = p.matcher(line);
			
				if (line.startsWith(pattern)) { // || m.matches()) {
				//	System.out.println(line);
					startsWith += 1;
				} else if (line.contains(pattern)) {
					contains += 1;
				
				}
				
				
		
			}
		
			System.out.println("Processed " + lineCount + " lines. Starts with " + startsWith + ". Other contains " + contains + " matches for file " + filename);
		}

	}

}