import java.io.File;
import java.util.ArrayList;
import java.util.List;

class Wait {

    public static void main(String[] args) throws java.lang.InterruptedException {

	List<File> files = new ArrayList<File>();
	for (String arg : args) {
	    files.add(new File(arg));
	}

	boolean done = false;

	while (! done) {

	    done = true;
	    for (File file : files) {
		if ( ! file.exists() ) {
		    done = false;
		    Thread.sleep(100);
		    break;
		}
	    }

	}

	System.out.println("Done waiting");
    }


}