import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GroupService {
  private apiUrl = 'http://127.0.0.1:8000/api/groups';

  constructor(private http: HttpClient) {}

  getGroupsByUser(userId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getUserGroups/${userId}`);
  }

  createGroup(groupData: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/create`, groupData);
  }

  getGroupById(groupId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getGroup/${groupId}`);
  }

  getGroupMembers(groupId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/getGroupMembers/${groupId}`);
  }

}

