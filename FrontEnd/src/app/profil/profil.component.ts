import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserService } from '../services/user.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './profil.component.html',
  styleUrl: './profil.component.css'
})
export class ProfilComponent {
  user: any;

  constructor(
    private userService: UserService
  ) {
    this.user = this.userService.getUserByToken(localStorage.getItem('token') as string);
  }
}
