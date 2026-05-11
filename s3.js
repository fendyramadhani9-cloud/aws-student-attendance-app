const { S3Client, GetObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');
const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
const multer = require('multer');
const multerS3 = require('multer-s3');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config();

// S3 Client - pakai IAM Role, tidak perlu credentials manual
const s3Client = new S3Client({
  region: process.env.AWS_REGION || 'us-east-1'
  // Credentials otomatis dari IAM Role EC2
});

const BUCKET_NAME = process.env.S3_BUCKET_NAME;

// Multer S3 untuk upload foto profil siswa
const uploadFotoProfil = multer({
  storage: multerS3({
    s3: s3Client,
    bucket: BUCKET_NAME,
    contentType: multerS3.AUTO_CONTENT_TYPE,
    key: function (req, file, cb) {
      const ext = file.originalname.split('.').pop();
      const key = `foto-profil/${uuidv4()}.${ext}`;
      cb(null, key);
    }
  }),
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Hanya file gambar yang diperbolehkan'), false);
    }
  },
  limits: { fileSize: 5 * 1024 * 1024 } // max 5MB
});

// Generate presigned URL untuk akses foto dari S3 (berlaku 1 jam)
const getPresignedUrl = async (key) => {
  if (!key) return null;
  try {
    const command = new GetObjectCommand({
      Bucket: BUCKET_NAME,
      Key: key
    });
    const url = await getSignedUrl(s3Client, command, { expiresIn: 3600 });
    return url;
  } catch (err) {
    console.error('Error generate presigned URL:', err);
    return null;
  }
};

// Hapus foto dari S3
const deleteFotoS3 = async (key) => {
  if (!key) return;
  try {
    const command = new DeleteObjectCommand({
      Bucket: BUCKET_NAME,
      Key: key
    });
    await s3Client.send(command);
  } catch (err) {
    console.error('Error hapus foto S3:', err);
  }
};

module.exports = { s3Client, uploadFotoProfil, getPresignedUrl, deleteFotoS3, BUCKET_NAME };
