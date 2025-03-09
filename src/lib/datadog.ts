import { datadogRum } from '@datadog/browser-rum';

datadogRum.init({
  applicationId: import.meta.env.VITE_DD_APPLICATION_ID || '',
  clientToken: import.meta.env.VITE_DD_CLIENT_TOKEN || '',
  site: 'datadoghq.com',
  service: 'pawsome-adoptions',
  env: import.meta.env.MODE,
  version: '1.0.0',
  sessionSampleRate: 100,
  sessionReplaySampleRate: 100,
  trackUserInteractions: true,
  trackResources: true,
  trackLongTasks: true,
  defaultPrivacyLevel: 'allow',
});

datadogRum.startSessionReplayRecording();

interface RumUser {
  id: string;
  email: string;
}

export const setRumUser = (user: RumUser | null) => {
  if (user) {
    datadogRum.setUser({
      id: user.id,
      email: user.email,
    });
  }
};