import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './profil.component.html',
  styleUrl: './profil.component.css'
})
export class ProfilComponent {
  user: any;
  isLoading: boolean = true;

  constructor(private userService: UserService) {}
  ngOnInit(): void {
    const token = localStorage.getItem('token') as string;
    this.userService.getUserByToken(token).subscribe({
      next: (response) => {
        this.user = response;
        this.isLoading = false;
        console.log('Utilisateur récupéré:', this.user);
      },
      error: (error) => {
        console.error('Erreur API:', error);
        this.isLoading = false;
      }
    });
  }
}
