import { Injectable } from '@angular/core';
import { IUser } from '../interfaces/iuser';

@Injectable({
  providedIn: 'root'
})
export class GlobalUserService {
  currentUser: IUser | null = null; 

  saveUser(user: IUser): void {
    this.currentUser = user;
    localStorage.setItem('currentUser', JSON.stringify(user));
  }

  restoreUser(): void {
    const user = localStorage.getItem('currentUser');
    if (user) {
      this.currentUser = JSON.parse(user);
    }
  }
}