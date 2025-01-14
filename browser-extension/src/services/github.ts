import browser from 'webextension-polyfill';
import { AuthState, GitHubUser, GitHubPR } from '../types/github';

const CLIENT_ID = 'Ov23liRH5JuqKVVIJg5q'; // You'll need to register your app on GitHub
const REDIRECT_URL = browser.identity.getRedirectURL();

export class GitHubService {
  private static async getAuthState(): Promise<AuthState> {
    const result = await browser.storage.local.get(['authState']);
    return result.authState || { token: null, user: null, customDomain: 'github.com' };
  }

  private static async setAuthState(state: AuthState): Promise<void> {
    await browser.storage.local.set({ authState: state });
  }

  static async login(): Promise<AuthState> {
    const state = Math.random().toString(36).substring(7);
    const authUrl = new URL('https://github.com/login/oauth/authorize');
    
    // Add required OAuth parameters
    authUrl.searchParams.append('client_id', CLIENT_ID);
    authUrl.searchParams.append('redirect_uri', REDIRECT_URL);
    authUrl.searchParams.append('state', state);
    authUrl.searchParams.append('scope', 'repo user');
    authUrl.searchParams.append('response_type', 'code');

    try {
      const responseUrl = await browser.identity.launchWebAuthFlow({
        url: authUrl.toString(),
        interactive: true
      });

      const url = new URL(responseUrl);
      const code = url.searchParams.get('code');
      const returnedState = url.searchParams.get('state');

      if (!code) {
        throw new Error('No authorization code received');
      }

      if (state !== returnedState) {
        throw new Error('State mismatch - possible CSRF attack');
      }

      // Exchange code for token using a proxy server
      const token = await this.getAccessToken(code);
      const user = await this.getCurrentUser(token);

      const authState = { token, user, customDomain: 'github.com' };
      await this.setAuthState(authState);
      return authState;

    } catch (error) {
      console.error('Login failed:', error);
      // Add more descriptive error message
      if (error instanceof Error) {
        throw new Error(`GitHub authentication failed: ${error.message}`);
      }
      throw error;
    }
  }

  static async logout(): Promise<void> {
    await this.setAuthState({ token: null, user: null, customDomain: 'github.com' });
  }

  static async getCurrentUser(token: string): Promise<GitHubUser> {
    const response = await fetch('https://api.github.com/user', {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return response.json();
  }

  static async getPullRequests(owner: string, repo: string): Promise<GitHubPR[]> {
    const authState = await this.getAuthState();
    if (!authState.token) throw new Error('Not authenticated');

    const response = await fetch(
      `https://api.github.com/repos/${owner}/${repo}/pulls?state=open`,
      {
        headers: {
          Authorization: `Bearer ${authState.token}`,
        },
      }
    );
    return response.json();
  }

  private static async getAccessToken(code: string): Promise<string> {
    // Point to local proxy server
    const tokenEndpoint = 'http://localhost:3000/token';
    
    const response = await fetch(tokenEndpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        code,
        client_id: CLIENT_ID,
        redirect_uri: REDIRECT_URL,
      }),
    });

    if (!response.ok) {
      throw new Error('Failed to exchange code for token');
    }

    const data = await response.json();
    return data.access_token;
  }
} 