import { CognitoUserPool, CognitoUser, AuthenticationDetails, CognitoUserSession } from 'amazon-cognito-identity-js';
import { loadConfig } from './resolver';

let userPool: CognitoUserPool | null = null;

const getUserPool = async () => {
  if (!userPool) {
    const config = await loadConfig();
    userPool = new CognitoUserPool({
      UserPoolId: config.userPoolId,
      ClientId: config.userPoolClientId,
    });
  }
  return userPool;
};

export const signIn = async (username: string, password: string): Promise<string> => {
  const pool = await getUserPool();
  
  return new Promise((resolve, reject) => {
    const user = new CognitoUser({ Username: username, Pool: pool });
    const authDetails = new AuthenticationDetails({ Username: username, Password: password });
    
    user.authenticateUser(authDetails, {
      onSuccess: (session: CognitoUserSession) => {
        resolve(session.getIdToken().getJwtToken());
      },
      onFailure: (err) => {
        reject(err);
      },
    });
  });
};

export const signOut = async () => {
  const pool = await getUserPool();
  const user = pool.getCurrentUser();
  if (user) {
    user.signOut();
  }
};

export const getCurrentSession = async (): Promise<string | null> => {
  const pool = await getUserPool();
  const user = pool.getCurrentUser();
  
  if (!user) {
    return null;
  }
  
  return new Promise((resolve) => {
    user.getSession((err: any, session: CognitoUserSession) => {
      if (err || !session.isValid()) {
        resolve(null);
      } else {
        resolve(session.getIdToken().getJwtToken());
      }
    });
  });
};
