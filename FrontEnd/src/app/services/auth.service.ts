import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../classes/user.model';
import { IUser } from '../interfaces/iuser';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://127.0.0.1:8000/api/auth';

  constructor(private http: HttpClient) {}

  createUser(userData: IUser): User {
    return new User(
      userData.first_name,
      userData.last_name,
      userData.email,
      userData.birthday,
      userData.password,
      userData.c_password,
      userData.username,
      userData.rank,
      userData.logo,
      userData.bio,
      userData.certified
    );
  }

  login(email: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, { email, password });
  }

  register(user: User): Observable<any> {
    return this.http.post(`${this.apiUrl}/register`, user);
  }
}
