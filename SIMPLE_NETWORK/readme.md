![alt text](image.png)



creating login key pair for instance.(on linux)
    >use the command "ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws_key_pair" to create the key

    >PRESS ENTER TWICE When prompted for a passphrase for auto-login testing or enter a secure password.

    >confirm both public and prite  key exist "ls -la ~/.ssh/"
    >we will submit "__ .pub" key to aws IN THE EC2_ACCESS FILE and we keep the privete key for ssh to the in stance 

    >SSH will reject private keys if their permissions are too open. Run these commands to set the standard secure file permissions:

            Bash
            chmod 700 ~/.ssh && chmod 600 ~/.ssh/aws_key && chmod 644 ~/.ssh/aws_key.pub
    
    > in the ec2_access file , we3c will use pathexpand() function to  turns ~/.ssh/aws_key_pair.pub into my/your computer file path to public e.g /Users/username/.ssh/aws_key_pair.pub automatically.To avoid typing the whole path ourself


    <>to ssh in to our machines Once Terraform provisions your EC2 instance, SSH will automatically look in your ~/.ssh/ folder by default, so you don't even need to pass the -i flag:

            Bash
            ssh -i ubuntu@<YOUR_INSTANCE_PUBLIC_IP>

            use terraform output to get the ip addresses

                        !!!DELETE THE KEYS AFTER DETELING THE RESOURCE!!!




















The Fix: Use SSH Agent Forwarding (Recommended)
Instead of manually copying your private key onto the public server (which is a security risk), use SSH Agent Forwarding. This lets your local machine safely share its private key for the second hop.

Follow these 3 steps on your local computer terminal:

Step 1: Add your private key to your local SSH Agent
Run this command on your local machine:

Bash
# Mac / Linux / Git Bash
ssh-add ~/.ssh/id_rsa
Note for Windows PowerShell users: If ssh-add says the agent is not running, start it first with Set-Service -Name ssh-agent -StartupType Automatic; Start-Service ssh-agent.

Verify that your key was added by running:

Bash
ssh-add -l
Step 2: SSH into your Public EC2 using the -A flag
The -A flag enables agent forwarding:

Bash
ssh -A ubuntu@<PUBLIC_EC2_PUBLIC_IP>
Step 3: SSH into the Private EC2
Now that you are inside your public instance, try connecting to the private instance again:

Bash
ssh ubuntu@10.0.2.106
It will now use your local computer's private key via agent forwarding and log you in successfully!