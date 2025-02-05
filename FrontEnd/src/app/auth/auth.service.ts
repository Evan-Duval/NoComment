import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'https:127.0.0.1/api/auth';

  constructor(private http: HttpClient) {}

  login(email: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, { email, password });
  }

  register(
    first_name: string,
    last_name: string,
    email: string, 
    birthday: Date,
    password: string,
    username: string, 
  ): Observable<any> {
    return this.http.post(`${this.apiUrl}/register`, { 
      first_name,
      last_name,
      email, 
      birthday,
      password,
      username,
    });
  }
}
