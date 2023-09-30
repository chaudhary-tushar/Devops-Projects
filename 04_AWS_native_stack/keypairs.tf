resource "aws_key_pair" "vprokey" {
  key_name = "vprofilekey"
  public_key = file(var.PUB_KEY_PATH)
}