export default {
  apiKey: process.env.DATADOG_API_KEY,
  applicationId: process.env.VITE_DD_APPLICATION_ID,
  service: 'pawsome-adoptions',
  minified: true,
  projectPath: './dist/',
  version: '1.0.0',
  stripCommentsFromSourcemap: true,
  sourceMapPathPrefix: '/',
  repository: 'https://github.com/yourusername/pawsome-adoptions',
  site: 'datadoghq.com'
};