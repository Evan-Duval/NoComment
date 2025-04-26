import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private apiUrl = 'http://127.0.0.1:8000/api/auth';

  constructor(private http: HttpClient) {}

  getUserByToken(token: string): Observable<any> {
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}`,
      'Accept': 'application/json'
    });

    return this.http.get<any>(`${this.apiUrl}/user`, { headers });
  }

  changePassword(email:string, passwordData: any): Observable<any> {

    const headers = new HttpHeaders({
      'Accept': 'application/json'
    });

    const data = {
      email: email,
      current_password: passwordData.current_password,
      new_password: passwordData.new_password,
      new_password_confirmation: passwordData.new_password_confirmation
    };

    return this.http.post<any>(`${this.apiUrl}/update-password`, data, { headers });
  }

  updateUser(id: string, userData: any): Observable<any> {
    const headers = new HttpHeaders({
      'Accept': 'application/json'
    });

    return this.http.post<any>(`${this.apiUrl}/update-user/${id}`, userData, { headers });
  }
}